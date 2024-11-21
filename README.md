# Minesweeper

## Requirements

- Building a simple Rails application that allows users to generate minesweeper boards as well as to view previously generated minesweeper boards. Include 3 pages:
  - Home page
  - Minesweeper board page
  - Minesweeper boards page

### Home page

- Contains a form to generate a new minesweeper board. The form should have the following fields:
  - `name` (name of the board)
  - `rows` (number of rows)
  - `columns` (number of columns)
  - `mines` (number of mines)
  - `email` (email address to send the board to)
- A list of previously generated minesweeper boards
  - Each item in the list should display the name of the board, the number of rows, columns, mines, and the email address the board was sent to.
  - On click the item should display the minesweeper board.
  - On the bottom of list have a link to go to the full list of minesweeper boards.

### Minesweeper board page

- Displays the minesweeper board.
- The board should be a grid of cells.

### Minesweeper boards page

- Displays a list of previously generated minesweeper boards.
- Has a link to go back to the home page.
- Has search functionality to filter the list of boards by name.
- Has pagination to display 10 boards per page.

## Specifications

- Framework: Rails
- Database: Mysql
- Tools: Docker
