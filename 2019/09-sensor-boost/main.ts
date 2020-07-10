import readInputFile from "../read-input-file.ts";
import { init, execute } from "../intcode-computer.ts";

const partOne = (): number => {
  return execute(init(readInputFile(), [1])).outputs[0];
};

const partTwo = (): number => {
  return execute(init(readInputFile(), [2])).outputs[0];
};

console.log(partOne());
console.log(partTwo());
