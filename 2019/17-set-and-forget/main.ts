import readInputFile from "../read-input-file.ts";
import { execute, init } from "../intcode-computer.ts";

const input = readInputFile();

type Route = (string | number)[];

enum Direction {
  up,
  down,
  left,
  right,
}

const directions = [
  Direction.up,
  Direction.down,
  Direction.left,
  Direction.right,
];

const next = (
  direction: Direction,
  [x, y]: [number, number],
  width: number,
): number => {
  switch (direction) {
    case Direction.up:
      return (y - 1) * width + x;
    case Direction.down:
      return (y + 1) * width + x;
    case Direction.left:
      return y * width + x - 1;
    case Direction.right:
      return y * width + x + 1;
  }

  throw "error";
};

const turn = (direction: Direction, turn: "L" | "R"): Direction => {
  return {
    [Direction.up]: { L: Direction.left, R: Direction.right },
    [Direction.down]: { L: Direction.right, R: Direction.left },
    [Direction.left]: { L: Direction.down, R: Direction.up },
    [Direction.right]: { L: Direction.up, R: Direction.down },
  }[direction][turn];
};

const partOne = (): number => {
  const outputs = execute(init(input)).outputs;
  const width = outputs.findIndex((o) => o == 10) + 1;

  return outputs.reduce((acc, o, i) => {
    if (o == 35) {
      const x = i % width;
      const y = Math.floor(i / width);

      if (directions.every((d) => outputs[next(d, [x, y], width)] == 35)) {
        return x * y + acc;
      }
    }

    return acc;
  }, 0);
};

const print = (outputs: number[]): void => {
  console.log(
    outputs.map((o) => {
      if (o != 10) {
        return String.fromCharCode(o);
      }

      return "\n";
    }).join(""),
  );
};

const partTwo = (): number => {
  const outputs = execute(init(input.replace(input[0], "2"))).outputs;
  const width = outputs.findIndex((o) => o == 10) + 1;
  let direction = Direction.up;
  let current = outputs.findIndex((o) => o == 94);

  let route = [] as Route;

  while (true) {
    const x = current % width;
    const y = Math.floor(current / width);

    const result = ["C", "L", "R"].map((t) => {
      const d = t != "C" ? turn(direction, t as "L") : direction;
      return [t, d, next(d, [x, y], width)] as [string, Direction, number];
    }).find((r) => outputs[r[2]] == 35);

    if (!result) {
      break;
    }

    direction = result[1];
    current = result[2];
    if (result[0] != "C") {
      route.push(result[0]);
      route.push(1);
    } else {
      const last = route.length - 1;
      route[last] = (route[last] as number) + 1;
    }
  }
  console.log(
    route.join("").replace(/L10L8R8/g, "").replace(/L8L10R6R8R8/g, "")
      .split(""),
  );

  // print(outputs);

  return 0;
};

// console.log(partOne());
console.log(partTwo());
