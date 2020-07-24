import readInputFile from "../read-input-file.ts";
import { init, execute } from "../intcode-computer.ts";

const input = readInputFile();

const partOne = (): number => {
  const outputs = execute(init(input)).outputs;
  let tiles = {} as Record<string, number>;

  for (let i = 0; i < outputs.length; i += 3) {
    const [x, y, id] = outputs.slice(i, i + 3);
    tiles[`${x},${y}`] = id;
  }

  return Object.values(tiles).filter((i) => i == 2).length;
};

console.log(partOne());
