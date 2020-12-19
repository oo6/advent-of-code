import readInputFile from "../read-input-file.ts";
import { execute, init } from "../intcode-computer.ts";

const input = readInputFile();

const partOne = (): number => {
  const outputs = execute(init(input)).outputs;
  const width = outputs.findIndex((o) => o == 10) + 1;

  return outputs.reduce((acc, o, i) => {
    if (o == 35) {
      const x = i % width;
      const y = Math.floor(i / width);

      if (
        x > 0 && x < width && y > 0 && y < (outputs.length / width) &&
        [(y - 1) * width + x, (y + 1) * width + x, i - 1, i + 1].every((j) =>
          outputs[j] == 35
        )
      ) {
        return x * y + acc;
      }
    }

    return acc;
  }, 0);
};

console.log(partOne());
