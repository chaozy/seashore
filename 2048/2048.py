from random import randrange, choice
import curses
from collections import defaultdict
from itertools import chain

letter_codes = [ord(char) for char in 'WASDPMwasdpm']
actions = ['Up', 'Left', 'Down', 'Right', 'Restart', 'Exit']
actions_to_code = dict(zip(letter_codes, actions * 2))

def get_actions(keyboard):
    char = "N"
    while char not in actions_to_code:
        char = keyboard.getch()
    return actions_to_code[char]

def transpose(field):
    #change the direction of the field
    return [list(row) for row in zip(*field)]

def invert(field):
    return [row[::-1] for row in field]

class GameField(object):
    def __init__(self, length = 4, width = 4, win_score = 2048):
        self.length = length
        self.width = width
        self.win_score = win_score
        self.score = 0
        self.highest_score = 0
        self.reset()

    def reset(self):
        if self.score > self.highest_score:
            self.highest_score = self.score
        self.score = 0
        self.field = [[0 for i in range(self.width)] for j in range(self.length)]
        self.spawn()
        #self.spawn()

    def move(self, direction):
    ，
        def move_row_left(row):
            def close(row): ##　put elements together
                new_row = [i for i in row if i != 0]
                new_row += [0 for i in range(len(row) - len(new_row))]
                return new_row

            def merge(row):
                pair = False
                new_row = []
                for i in range(len(row)):
                    if pair:
                        new_row.append(2 * row[i])
                        self.score += 2 * row[i]
                        pair = False
                    else:
                        if i + 1 < len(row) and row[i] == row[i + 1]:
                            pair = True
                            new_row.append(0)
                        else:
                            new_row.append(row[i])
                assert len(new_row) == len(row) 
                return new_row
            return close(merge(close(row)))

        moves = {}
        moves['Left'] = lambda field: [move_row_left(row) for row in field]
        moves['Right'] = lambda field: invert(moves['Left'](invert(field)))
        moves['Up'] = lambda field: transpose(moves['Left'](transpose(field)))
        moves['Down'] = lambda field: transpose(moves['Right'](transpose(field)))

        if direction in moves:
            if self.can_move(direction):
                self.field = moves[direction](self.field)
                self.spawn()
                return True
            else:
                return False

    def is_win(self):
        #   * parse the two dimensional array and convert it to one dimensional
        field2 = chain(*self.field)
        return max(field2) >= self.win_score
    '''def is_win(self):
        return any(any(i >= self.win_score for i in row) for row in self.field)'''

    def is_lose(self):
        return not any(self.can_move(move) for move in actions)

    def drawn(self, screen):
        rule1 = "use wasd to move the numbers"
        rule2 = "p for restart & m for exit"
        game_over = "       GAME OVER!!!!!"
        game_win = "        GAME WIN!!!!"

        def cast(string):
            screen.addstr(string + '\n')

        def draw_horizontal():
            line = '+' + ("+----------------" * self.width + '+')[1:]
            separator = defaultdict(lambda: line)
            if not hasattr(draw_horizontal, "counter"):
                draw_horizontal.counter = 0
            cast(separator[draw_horizontal.counter])
            draw_horizontal.counter += 1

        def draw_row(row):
            cast(''.join('|{: ^12}    '.format(num) if num > 0 else '|                'for num in row) + '|')

        screen.clear()
        cast("SCORE IS:  " + str(self.score))
        cast("HIGHEST SCORE IS:  " + str(self.highest_score))
        for row in self.field:
            draw_horizontal()
            draw_row(row)
        draw_horizontal()
        if self.is_win():
            cast(game_win)
        else:
            if self.is_lose():
                cast(game_over)
            else:
                cast(rule1)
        cast(rule2)

    def spawn(self):
        new_element = 4 if randrange(10) >= 9 else 2
        (i, j) = choice([(i, j) for i in range(self.width)for j in range(self.length) if self.field[i][j] == 0])
        self.field[i][j] = new_element

    def can_move(self,direction):
        def left_isok(row):
            def change(i):
                if row[i] == 0 and row[i + 1] != 0:
                    return True
                if row[i + 1] == row[i] and row[i] != 0:
                    return True
                return False
            return any(change(i) for i in range(len(row) - 1))

        check = {}
        check['Left'] = lambda field : any(left_isok(row) for row in field)
        check['Right'] = lambda field : check["Left"](invert(field))
        check['Up'] = lambda field: check["Left"](transpose(field))
        check['Down'] = lambda field: check["Right"](transpose(field))

        if direction in check:
            return check[direction](self.field)
        else:
            return False

def main(stdscr):
        # 重置游戏棋盘
        game_field.reset()
        return 'Game'

    def not_game(state):
        game_field.drawn(stdscr)
        action = get_actions(stdscr)
        responses = defaultdict(lambda: state) 
        responses['Restart'], responses['Exit'] = 'Init', 'Exit' 
        return responses[action]

    def game():

        game_field.drawn(stdscr)
        action = get_actions(stdscr)

        if action == 'Restart':
            return 'Init'
        if action == 'Exit':
            return 'Exit'
        if game_field.move(action):
            if game_field.is_win():
                return 'win'
            if game_field.is_lose():
                return 'Gameover'
        return 'Game'

    state_actions = {
        'Init': init,
        'Win': lambda: not_game('Win'),
        'Gameover': lambda: not_game('Gameover'),
        'Game': game
    }

    curses.use_default_colors()
    game_field = GameField(win_score = 2048)
    state = 'Init'
    while state != 'Exit':
        state = state_actions[state]()

curses.wrapper(main) #Open the window then excute the main function, and close the window after finishing excution