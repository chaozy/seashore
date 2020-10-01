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
   -- toList Empty = []
   -- toList (Node x left right ) = toList(left) ++ [x] ++ toList (right)
   -- method 2:
   toList Empty = []
   toList s@(Node _ _ _) = setfoldr (:) s []
   

   -- fromList [2,1,1,4,5] => {2,1,4,5}

   -- get rid of all the duplications in the list
   killDup :: Eq a => [a] -> [a] -> [a]
   killDup xs [] = xs
   killDup xs (y:ys) = if y `elem` xs then killDup xs ys else killDup (xs ++ [y]) ys

   fromList :: Ord a => [a] -> Set a
   fromList [] = Empty
   fromList xs = Node (sortedList !! half) (fromList (take half sortedList)) (fromList (drop (half+1) sortedList))
                  where half = div (length sortedList) 2 
                        sortedList = isort (killDup [] xs)
   
   
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

   -- implementation of insertIn is in the end
   insert :: (Ord a) => a -> Set a -> Set a
   insert x Empty = Node x Empty Empty
   insert x s@(Node _ _ _) = fromList ([x] ++ (toList s))
   
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
   difference _ Empty = Empty
   difference a b = fromList (differenceList (toList a) (toList b))
   
   -- is element *a* in the Set?
   member :: (Ord a) => a -> Set a -> Bool
   member i Empty = False
   member i (Node n left right) = if i == n then True else ((member i left) || (member i right)) 
   
   
   -- how many elements are there in the Set?
   cardinality :: Set a -> Int
   cardinality Empty = 0
   cardinality s@(Node x left right) = setfoldr (\_ n -> n+1) s 0
   
   
   setmap :: (Ord b) => (a -> b) -> Set a -> Set b
   setmap m Empty = Empty
   setmap m s@(Node x left right) = fromList (map m (toList s))
   
   
   setfoldr :: (a -> b -> b) -> Set a -> b -> b
   -- Method 1:
   setfoldr f Empty s = s
   setfoldr f (Node x left right) s = setfoldr f left (f x (setfoldr f right s))
   --Method 2:
   -- setfoldr f Empty s = s
   -- setfoldr f s@(Node x left right) s = foldr f s (toList s)
   
   
   -- powerset of a set
   -- powerset {1,2} => { {}, {1}, {2}, {1,2} }

   simplifiedFromList :: [a] -> Set a -- the reason why it is called simpliedfromList is that it doesn't have the Ord constraint
   simplifiedFromList [] = Empty
   simplifiedFromList xs = Node (xs !! half) (simplifiedFromList (take half xs)) (simplifiedFromList (drop (half+1) xs))
                  where half = div (length xs) 2 

   powerList' :: [a] -> [[a]]
   powerList' [] = []
   powerList' (x:xs) = [x]:map(x:) (powerList' xs) ++ powerList' xs

   powerList :: [a] -> [[a]]
   powerList xs = [] : powerList' xs

   powerSet :: Set a -> Set (Set a)
   powerSet Empty = Node Empty Empty Empty
   powerSet s@(Node x left right) = simplifiedFromList [simplifiedFromList subList | subList <- powerList (toList s)]
   

   -- cartesian product of two sets
   cartesian :: Set a -> Set b -> Set (a, b)
   cartesian a Empty = Empty
   cartesian Empty b = Empty
   cartesian a b = simplifiedFromList [(x, y) | x <- toList a, y <- toList b]
   
   
   -- partition the set into two sets, with
   -- all elements that satisfy the predicate on the left,
   -- and the rest on the right
   partition :: (a -> Bool) -> Set a -> (Set a, Set a)
   partition f Empty = (Empty, Empty)
   partition f s@(Node x left right) = (simplifiedFromList [n | n <- toList s, f n], simplifiedFromList [n | n <- toList s, not (f n)])



   -- isort
   removeLast :: [a] -> [a] 
   removeLast [a] = []
   removeLast (x:xs) = [x] ++ removeLast (xs)

   insertIn :: Ord a => a -> [a] -> [a]
   insertIn a xs = [x | x <- xs, x < a] ++ [a] ++ [x | x <- xs, x >= a]

   isort :: Ord a => [a] -> [a]
   isort [a] = [a]
   isort xs = insertIn (last xs) (isort (removeLast xs))
   
   
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
   