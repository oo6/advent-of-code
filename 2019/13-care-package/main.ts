import readInputFile from "../read-input-file.ts";
import { init, execute, IContext } from "../intcode-computer.ts";

const input = readInputFile();

enum Tile {
  empty,
  wall,
  block,
  paddle,
  ball,
}

class Game {
  context: IContext;

  blocks: Map<string, true> = new Map();

  paddle: [number, number] = [0, 0];

  ball: [number, number] = [0, 0];

  score = 0;

  constructor(context: IContext) {
    this.context = execute(context);
    this.processOutputs(this.context.outputs);
  }

  play() {
    const inputs = this.paddle[0] == this.ball[0]
      ? [0]
      : (this.paddle[0] < this.ball[0] ? [1] : [-1]);
    this.context = execute({ ...this.context, inputs });
    this.processOutputs(this.context.outputs);
  }

  private processOutputs(outputs: number[]) {
    for (let i = 0; i < outputs.length; i += 3) {
      const [x, y, id] = outputs.slice(i, i + 3);

      if (x == -1 && y == 0) {
        this.score = id;
        continue;
      }

      switch (id) {
        case Tile.empty:
          this.blocks.delete(`${x},${y}`);
          break;
        case Tile.block:
          this.blocks.set(`${x},${y}`, true);
          break;
        case Tile.paddle:
          this.paddle = [x, y];
          break;
        case Tile.ball:
          this.ball = [x, y];
          break;
      }
    }
  }
}

const partOne = (): number => {
  const game = new Game(init(input));
  return game.blocks.size;
};
const partTwo = (): number => {
  const context = init(["2", ...input.split(",").slice(1)].join());
  const game = new Game(context);

  while (game.blocks.size) {
    game.play();
  }

  return game.score;
};

console.log(partOne());
console.log(partTwo());
