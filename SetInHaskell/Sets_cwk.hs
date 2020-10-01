module Coursework where

   {-
     Your task is to design a datatype that represents the mathematical concept of a (finite) set of elements (of the same type).
     We have provided you with an interface (do not change this!) but you will need to design the datatype and also 
     support the required functions over sets.
     Any functions you write should maintain the following invariant: no duplication of set elements.
   
     There are lots of different ways to implement a set. The easiest is to use a list
     (as in the example below). Alternatively, one could use an algebraic data type,
     wrap a binary search tree, or even use a self-balancing binary search tree.
     Extra marks will be awarded for efficient implementations (a self-balancing tree will be
     more efficient than a linked list for example).
   
     You are NOT allowed to import anything from the standard library or other libraries.
     Your edit of this file should be completely self-contained.
   
     DO NOT change the type signatures of the functions below: if you do,
     we will not be able to test them and you will get 0% for that part. While sets are unordered collections,
     we have included the Ord constraint on most signatures: this is to make testing easier.
   
     You may write as many auxiliary functions as you need. Please include everything in this file.
   -}
   
   {-
      PART 1.
      You need to define a Set datatype. Below is an example which uses lists internally.
      It is here as a guide, but also to stop ghci complaining when you load the file.
      Free free to change it.
   -}
   
   -- you may change this to your own data type
   --newtype Set a = Set { unSet :: [a] } deriving (Show,  Ord)
   -- data Set a = Empty | Set a (Set a) 
   --          deriving (Read, Show)
   data Set a = Empty | Node a (Set a) (Set a) deriving (Show, Ord)

   {-
      PART 2.
      If you do nothing else, at least get the following two functions working. They
      are required for testing purposes.
   -}

   -- toList {2,1,4,3} => [1,2,3,4]
   -- the output must be sorted.
   toList :: Set a -> [a]
   -- method 1: 
   -- toList (Empty) = []
   -- toList (Node x left right ) = toList(left) ++ [x] ++ toList (right)
   -- method 2:
   toList (Empty) = []
   toList (Node x left right) = setfoldr (:) (Node x left right) []
   

   -- fromList [2,1,1,4,5] => {2,1,4,5}
   setInsert :: (Ord a) => a -> Set a -> Set a
   setInsert a Empty = Node a Empty Empty
   setInsert a (Node n left right) | n == a = Node n left right
                                   | a < n = Node n (setInsert a left) right
                                   | otherwise = Node n left (setInsert a right) 

   fromList :: Ord a => [a] -> Set a
   fromList xs = foldr setInsert Empty xs
   
   
   {-
      PART 3.
      Your Set should contain the following functions.
      DO NOT CHANGE THE TYPE SIGNATURES.
   -}
   
   -- test if two sets have the same elements.

   instance (Ord a) => Eq (Set a) where
     s1 == s2 = (toList s1) == (toList s2)
   
   
   -- the empty set
   empty :: Set a
   empty = Empty
   
   
   -- Set with one element
   singleton :: a -> Set a
   singleton a = Node a Empty Empty
   
   
   -- insert an element of type a into a Set
   -- make sure there are no duplicates!
   insert :: (Ord a) => a -> Set a -> Set a
   insert a Empty = singleton a
   insert a (Node n left right) | n == a = Node n left right
                                | a < n = Node n (insert a left) right
                                | otherwise = Node n left (insert a right) 
   
   -- join two Sets together
   -- be careful not to introduce duplicates.
   union :: (Ord a) => Set a -> Set a -> Set a
   union a b = foldr insert b (toList a)
   
   
   -- return the common elements between two Sets
   checkRepeat :: Eq a => a -> [a] -> Bool
   checkRepeat n xs = null ([x | x <- xs, x == n])

   intersectList :: Eq a => [a] -> [a] -> [a]
   intersectList a b = [x | x <- a, (checkRepeat x b) == False]

   intersection :: (Ord a) => Set a -> Set a -> Set a
   intersection a b = fromList (intersectList (toList a) (toList b))
   
   
   -- all the elements in Set A *not* in Set B,
   -- {1,2,3,4} `difference` {3,4} => {1,2}
   -- {} `difference` {0} => {}
   differenceList :: Eq a => [a] -> [a] -> [a]
   differenceList a b = [x | x <- a, (checkRepeat x b)]

   difference :: (Ord a) => Set a -> Set a -> Set a
   difference Empty _ = Empty
   difference a b = fromList (differenceList (toList a) (toList b))
   
   -- is element *a* in the Set?
   member :: (Ord a) => a -> Set a -> Bool
   member i Empty = False
   member i (Node n left right) = if i == n then True else ((member i left) || (member i right)) 
   
   
   -- how many elements are there in the Set?
   cardinality :: Set a -> Int
   cardinality Empty = 0
   cardinality (Node x left right) = setfoldr (\_ n -> n+1) (Node x left right ) 0
   
   
   setmap :: (Ord b) => (a -> b) -> Set a -> Set b
   setmap m Empty = Empty
   setmap m (Node x left right) = fromList (map m (toList (Node x left right)))
   
   
   setfoldr :: (a -> b -> b) -> Set a -> b -> b
   -- Method 1:
   setfoldr f Empty s = s
   setfoldr f (Node x left right) s = setfoldr f left (f x (setfoldr f right s))
   --Method 2:
   -- setfoldr f Empty s = s
   -- setfoldr f (Node x left right) s = foldr f s (toList (Node x left right))
   
   
   -- powerset of a set
   -- powerset {1,2} => { {}, {1}, {2}, {1,2} }
   emptySet :: Set (Set a)
   emptySet = Node Empty Empty Empty
   
   comparsion :: Set a -> Bool
   comparsion Empty = False 
   comparsion (Node _ _ _) = True

   insertInOrder :: a -> Set a -> Set a
   insertInOrder x Empty = Node x Empty Empty
   insertInOrder x (Node n left right) = if (comparsion left) then (if (comparsion right) then Node n (insertInOrder x left) right else Node n left (insertInOrder x right))
                                                            else Node n (insertInOrder x left) right

   insertInOrd :: a -> Set a -> Set a
   insertInOrd x Empty = Node x Empty Empty
   insertInOrd x (Node n left right) = Node n (insertInOrd x left) right

   powerList :: [a] -> [[a]]
   powerList [] = [[]]
   powerList (x:xs) = [x:s | s <- powerList xs] ++ powerList xs

   powerSet :: Set a -> Set (Set a)
   powerSet Empty = emptySet
   powerSet s@(Node x left right) = foldr insertInOrd Empty ([if null subList then Empty else (foldr insertInOrd Empty subList) | subList <- powerList (toList s)])
   
   
   -- cartesian product of two sets
   cartesian :: Set a -> Set b -> Set (a, b)
   cartesian a Empty = Empty
   cartesian Empty b = Empty
   cartesian a b = foldr insertInOrder Empty [(x, y) | x <- toList a, y <- toList b]
   
   
   -- partition the set into two sets, with
   -- all elements that satisfy the predicate on the left,
   -- and the rest on the right
   partition :: (a -> Bool) -> Set a -> (Set a, Set a)
   partition f Empty = (Empty, Empty)
   partition f s@(Node x left right) = (foldr insertInOrd Empty [n | n <- toList s, f n], foldr insertInOrd Empty [n | n <- toList s, not (f n)])

   
   
   
   {-
      On Marking:
      Be careful! This coursework will be marked using QuickCheck, against Haskell's own
      Data.Set implementation. Each function will be tested for multiple properties.
      Even one failing test means 0 marks for that function.
   
      Marks will be lost for too much similarity to the Data.Set implementation.
   
      Pass: creating the Set type and implementing toList and fromList is enough for a
      passing mark of 40%.
   
      The maximum mark for those who use lists, as in the example above, is 70%. To achieve
      a higher grade than is, one must write a more efficient implementation.
      100% is reserved for those brave few who write their own self-balancing binary tree.
   -}
   