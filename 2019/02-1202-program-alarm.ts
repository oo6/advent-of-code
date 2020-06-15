const input =
  "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,9,1,19,1,9,19,23,1,23,5,27,2,27,10,31,1,6,31,35,1,6,35,39,2,9,39,43,1,6,43,47,1,47,5,51,1,51,13,55,1,55,13,59,1,59,5,63,2,63,6,67,1,5,67,71,1,71,13,75,1,10,75,79,2,79,6,83,2,9,83,87,1,5,87,91,1,91,5,95,2,9,95,99,1,6,99,103,1,9,103,107,2,9,107,111,1,111,6,115,2,9,115,119,1,119,6,123,1,123,9,127,2,127,13,131,1,131,9,135,1,10,135,139,2,139,10,143,1,143,5,147,2,147,6,151,1,151,5,155,1,2,155,159,1,6,159,0,99,2,0,14,0";

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

export {};