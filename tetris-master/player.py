from board import Direction, Rotation
from random import Random


class Player:
    def getHoles(self, board):
        holes = 0
        for x in range(board.width):
            colHoles = -1
            for y in range(board.height):
                if colHoles == -1 and (x, y) in board.cells:
                    colHoles = 0
                if colHoles != -1 and (x, y) not in board.cells:
                    colHoles += 1
            if colHoles != -1:
                holes += colHoles
        #print("holes", holes)
        return holes

    def getWells(self, board):
        depths = [0, 1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 66, 78, 91, 105, 120, 136, 153, 171, 190, 210]
        totalWell = 0
        well = 0
        for x in range(board.width):
            for y in range(board.height):
                if (x, y) not in board.cells:
                    if ((x - 1, y) in board.cells or x - 1 < 0) and (x + 1 == board.width or (x + 1, y) in board.cells):
                        well += 1
                else:
                    totalWell += depths[well]
                    well = 0
        #print("wells: ", totalWell)
        return totalWell

    def getHeight(self, board):
        maxHeight = 0
        for y in range(board.height):
            for x in range(board.width):
                if (x, y) in board.cells and y < board.height - maxHeight:
                    maxHeight = board.height - y
        # return board.height - board.falling.center[1]
        #print("height: ", maxHeight)
        return maxHeight

    def getErasedLine(self, board): #rows eliminated
        line = 0
        for y in range(board.height - 1, 0, -1):
            count = 0
            for x in range(board.width):
                if (x, y) in board.cells: count += 1
                if count == 10:
                    line += 1
            if count == 0: break
        #print("line ", line)
        return line

    # Row Transitions: The total number of row transitions.
    # A row transition occurs when an empty cell is adjacent to a filled cell on the same row and vice versa.
    def getRowTransitions(self, board):
        trans = 0
        for y in range(board.height - 1, 0, -1):
            count = 0
            for x in range(board.width):
                if (x, y) in board.cells:
                    count += 1
                if (x, y) in board.cells and (x + 1, y) not in board.cells:
                    trans += 1
                if (x, y) not in board.cells and (x + 1, y) in board.cells:
                    trans += 1
            if count == 0: break
        return trans

    def getColTransitions(self, board):
        trans = 0
        for x in range(board.width):
            for y in range(board.height):
                if (x, y) in board.cells and (x, y + 1) not in board.cells:
                    trans += 1
                if (x, y) not in board.cells and (x, y + 1) in board.cells:
                    trans += 1
        return trans

    def noIdea(self, rot1, shift1, board):
        sandbox = board.clone()
        flag = True
        for i in range(rot1):
            if sandbox.rotate(Rotation.Clockwise):
                flag = False
                break
        #print("after rotation: ", sandbox.falling.center)
        if flag:
            if shift1 > 0:
                for x in range(shift1):
                    if sandbox.move(Direction.Right):
                        flag = False
                        break
            elif shift1 < 0:
                for y in range(shift1, 0, 1):
                    if sandbox.move(Direction.Left):
                        flag = False
                        break

        return self.getScore(sandbox, flag)

    def something(self, board):
        #now = board.falling
        maxScore = float('-inf')
        for rot1 in range(4):
            for shift1 in range(-5, 6):
                currentScore = self.noIdea(rot1, shift1, board)
                #print("currentScore", rot1, shift1, currentScore)
                if currentScore >= maxScore:
                    maxScore = currentScore
                    rot = rot1
                    shift = shift1
                    #print("currentScore", rot1, shift1, currentScore)
        #print([rot, shift])
        return [rot, shift]

    def getScore(self, board, flag):
        lineFirst = self.getHeight(board)
        if flag:
            board.move(Direction.Drop)
        coOfHoles = 10.899265427351652  # the best so far
        coOfElminated = 3.4181268101392694
        coOfHeight = 10.500158825082766
        coOfRowTrans = 3.2178882868487753

        hole = self.getHoles(board)
        print("hole: ", hole)


        if hole > 13:
            coOfHoles += 1

        #else:
            #coOfHoles -= 2
            #coOfElminated += 1

        well = self.getWells(board)
        height = self.getHeight(board)
        eliminated = self.getHeight(board) - lineFirst
        #print("lines: ", eliminated)
        rowTrans = self.getRowTransitions(board)
        colTrans = self.getColTransitions(board)
        score = -coOfHeight * height + coOfElminated * eliminated - coOfRowTrans * rowTrans - 9.348695305445199 * colTrans - coOfHoles * hole - 3.3855972247263626 * well

        return score

    def choose_action(self, board):
        #raise NotImplementedError
        instruction = self.something(board)
        print(instruction)
        lis = []
        for i in range(instruction[0]):
            lis.append(Rotation.Clockwise)
        if instruction[1] < 0:
            for i in range(0, instruction[1], -1):
                lis.append(Direction.Left)
        else:
            for i in range(instruction[1]):
                lis.append(Direction.Right)
        lis.append(Direction.Drop)
        return lis


class RandomPlayer(Player): # why inherit player here
    def __init__(self, seed=None):
        self.random = Random(seed)

    def choose_action(self, board):

        return self.random.choice([
            Direction.Left,
            Direction.Right,
            Direction.Down,
            Rotation.Anticlockwise,
            Rotation.Clockwise,
        ])

class Player2:  #stupid method in order to beat the random
    def __init__(self):
        self.count = 0

    def choose_action(self, board):
        self.count+= 1
        if self.count % 3 == 0:
            return [Direction.Left for i in range(5)] + [Direction.Drop]
        elif self.count % 3 == 1:
            return [Direction.Drop]
        elif self.count % 3 == 2:
            return [Direction.Right for i in range(5)] + [Direction.Drop]

class Player3:
    def noIdea(self, rot1, shift1, board):
        sandbox = board.clone()
        #print("old center", sandbox.falling.center)
        #sandbox.rotate(Rotation.Anticlockwise)
        #sandbox.move(Direction.Drop)
        flag = True
        for i in range(rot1):
            if sandbox.rotate(Rotation.Clockwise):
                flag = False
                break
        #print("after rotation: ", sandbox.falling.center)
        if flag:
            if shift1 > 0:
                for x in range(shift1):
                    if sandbox.move(Direction.Right):
                        flag = False
                        break
                #print("after shift", sandbox.falling.center)
            elif shift1 < 0:
                for y in range(shift1, 0, 1):
                    if sandbox.move(Direction.Left):
                        flag = False
                        break

        if flag:
            sandbox.move(Direction.Drop)
        #print("center", sandbox.falling.center)
        #print("score: ", self.getScore(sandbox))
        #print(rot1, shift1)
        #print(sandbox.cells)
        return self.getScore(sandbox)

    def something(self, board):
        #now = board.falling
        maxScore = float('-inf')
        for rot1 in range(4):
            for shift1 in range(-4, 5):
                currentScore = self.noIdea(rot1, shift1, board)
                print("currentScore", rot1, shift1, currentScore)
                if currentScore >= maxScore:
                    maxScore = currentScore
                    rot = rot1
                    shift = shift1
                    #print("currentScore", rot1, shift1, currentScore)
        #print([rot, shift])
        return [rot, shift]

    def getAggregateHeight(self, board):
        totalHeight = 0
        for x in range(board.width):
            for y in range(board.height):
                if (x, y) in board.cells:
                    totalHeight += (board.height - y)
                    break
        #print("height", totalHeight)
        return totalHeight

    def getErasedLine(self, board): #rows eliminated
        line = 0
        for y in range(board.height - 1, 0, -1):
            count = 0
            for x in range(board.width):
                if (x, y) in board.cells: count += 1
                if count == 10:
                    line += 1
            if count == 0: break
        #print("line ", line)
        return line

    def getHoles(self, board):
        holes = 0
        for x in range(board.width):
            colHoles = -1
            for y in range(board.height):
                if colHoles == -1 and (x, y) in board.cells:
                    colHoles = 0
                if colHoles != -1 and (x, y) not in board.cells:
                    colHoles += 1
            if colHoles != -1:
                holes += colHoles
        #print("holes", holes)
        return holes

    def getBumpiness(self, board):
        total = 0
        for x in range(board.width):
            previous = 0
            this = 0
            for y in range(board.height):
                if (x, y) in board.cells:
                    if x == 0:
                        this = board.height - y
                        previous = this - y
                    else:
                        this = board.height - y
                        total += abs(this - previous)
                        previous = this
        return total

    def choose_action(self, board):
        #raise NotImplementedError
        instruction = self.something(board)
        print(instruction)
        lis = []
        for i in range(instruction[0]):
            lis.append(Rotation.Clockwise)
        if instruction[1] < 0:
            for i in range(0, instruction[1], -1):
                lis.append(Direction.Left)
        else:
            for i in range(instruction[1]):
                lis.append(Direction.Right)
        lis.append(Direction.Drop)
        #print(lis)
        #for i in lis:
            #yield i
        return lis

    def getScore(self, board):
        holes = self.getHoles(board)
        lines = self.getErasedLine(board)
        bump = self.getBumpiness(board)
        height = self.getAggregateHeight(board)
        score = -0.51 * height + 0.760666 * lines - 0.35663 * holes - 0.184483 * bump
        #print("score: ", score)
        return score
SelectedPlayer = Player