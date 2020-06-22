import readInputFile from "../read-input-file.ts";

const input = readInputFile();

enum OP {
  ADD = 1,
  MULT = 2,
  HALT = 99,
}

const execute = (origin: number[], noun: number, verb: number): number => {
  const list = [origin[0], noun, verb, ...origin.slice(3)];

  for (let pos = 0; pos < list.length; pos = pos + 4) {
    const [code, first, second, save] = list.slice(pos, pos + 4);
    switch (code) {
      case OP.ADD:
        list[save] = list[first] + list[second];
        break;
      case OP.MULT:
        list[save] = list[first] * list[second];
        break;
      case OP.HALT:
        break;
    }
  }

  return list[0];
};

const partOne = (): number => {
  let list = input.split(",").map((i) => ~~i);
  return execute(list, 12, 2);
};

const partTwo = (): number => {
  const list = input.split(",").map((i) => ~~i);

  for (let noun = 0; noun < 100; noun++) {
    for (let verb = 0; verb < 100; verb++) {
      if (19690720 == execute(list, noun, verb)) {
        return 100 * noun + verb;
      }
    }
  }

  throw "error";
};

console.log(partOne());
console.log(partTwo());
