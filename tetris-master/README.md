# Tetrix-Master

tetrix-master is an auto tetrix player.

## Usage

Normal Speed

```bash
python visual.py
```

Fast Speed

```bash
python visual-pygame.py
```

## Description

This algorithm is based on the idea on https://luckytoilet.wordpress.com/2011/05/27/coding-a-tetris-ai-using-a-genetic-algorithm/

I haven't write the generic algorithm to find the best weight for each factor. It will be added in later.

The base framework was created by Prof. Mark Handley, and he prepared a ton of random orientations of falling blocks.
To change the orientation, change the constant
```python
DEFAULT_SEED
```
in constants.py to another integer.
