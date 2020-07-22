import readInputFile from "../read-input-file.ts";
import { init, execute } from "../intcode-computer.ts";

const input = readInputFile();

type Coordinate = [number, number];
type Direction = 0 | 1;

enum Facing {
  UP = "^",
  DOWN = "v",
  LEFT = "<",
  RIGHT = ">",
}

const Next = {
  [Facing.UP]: {
    0: Facing.LEFT,
    1: Facing.RIGHT,
    run: ([x, y]: Coordinate): Coordinate => [x, y + 1],
  },
  [Facing.DOWN]: {
    0: Facing.RIGHT,
    1: Facing.LEFT,
    run: ([x, y]: Coordinate): Coordinate => [x, y - 1],
  },
  [Facing.LEFT]: {
    0: Facing.DOWN,
    1: Facing.UP,
    run: ([x, y]: Coordinate): Coordinate => [x - 1, y],
  },
  [Facing.RIGHT]: {
    0: Facing.UP,
    1: Facing.DOWN,
    run: ([x, y]: Coordinate): Coordinate => [x + 1, y],
  },
};

const paint = (defaultColor: number): Record<string, number> => {
  let current = "0,0", facing = Facing.UP, context = init(input);
  const panels: Record<string, number> = { [current]: defaultColor };

  while (true) {
    const color = panels[current] || 0;
    context = execute({ ...context, inputs: [color], outputs: [] });

    color != context.outputs[0] && (panels[current] = context.outputs[0]);
    facing = Next[facing][context.outputs[1] as Direction];
    current = Next[facing].run(
      current.split(",").map((i) => ~~i) as Coordinate,
    ).join(",");

    if (context.state == "halt") break;
  }

  return panels;
};

const partOne = (): number => {
  return Object.keys(paint(0)).length;
};

const partTwo = (): string => {
  const panels = paint(1);
  const coords = Object.keys(panels).map((c) => c.split(",").map((i) => ~~i));

  const xCoords = coords.map(([x, _]) => x),
    yCoords = coords.map(([_, y]) => y);
  const xMax = Math.max(...xCoords),
    xMin = Math.min(...xCoords),
    yMax = Math.max(...yCoords),
    yMin = Math.min(...yCoords);
  const xOffset = 0 - xMin, yOffset = 0 - yMin;

  return Array.from(
    Array(yMax - yMin + 1),
    (_, y) =>
      Array.from(
        Array(xMax - xMin + 1),
        (_, x) =>
          panels[`${x - xOffset},${(yMax - yMin) - y - yOffset}`] == 1
            ? "*"
            : " ",
      ).join(""),
  ).join("\n");
};

console.log(partOne());
console.log(partTwo());
