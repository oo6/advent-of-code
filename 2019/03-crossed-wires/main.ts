import readInputFile from "../read-input-file.ts";

const input = readInputFile();

interface Points {
  [propName: string]: number;
}

interface Calculate {
  (x: number, y: number, steps: number, points: Points): number;
}

const wires: [string, number][][] = input
  .split("\n")
  .map((line) =>
    line
      .split(",")
      .map((item) => [item[0], ~~item.slice(1)])
  );

const next = (x: number, y: number, direction: string): number[] => {
  switch (direction) {
    case "U":
      return [x, y + 1];
    case "D":
      return [x, y - 1];
    case "L":
      return [x - 1, y];
    case "R":
      return [x + 1, y];
    default:
      throw "error";
  }
};

const walk = (func: Calculate): number => {
  let points: Points = {};
  let crossed = [];

  for (let i = 0; i < wires.length; i++) {
    let x = 0, y = 0, steps = 0;

    for (let j = 0; j < wires[i].length; j++) {
      const [direction, length] = wires[i][j];

      for (let k = 0; k < length; k++) {
        [x, y] = next(x, y, direction);
        steps++;

        const key = `${x},${y}`;
        if (i == 0 && !points[key]) {
          points[key] = steps;
        }
        if (i == 1 && points[key]) {
          crossed.push(func(x, y, steps, points));
        }
      }
    }
  }

  return Math.min(...Object.values(crossed));
};

const partOne = (): number => {
  return walk((x: number, y: number) => Math.abs(x) + Math.abs(y));
};

const partTwo = (): number => {
  return walk((x: number, y: number, steps: number, points: Points) =>
    points[`${x},${y}`] + steps
  );
};

console.log(partOne());
console.log(partTwo());
