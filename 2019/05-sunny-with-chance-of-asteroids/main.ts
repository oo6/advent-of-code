import readInputFile from "../read-input-file.ts";

const input = readInputFile();

enum OP {
  ADD = 1,
  MULT,
  INPUT,
  OUTPUT,
  IF,
  UNLESS,
  LESS_THAN,
  EQUAL,
  HALT = 99,
}

const get = (list: number[], mode: number, value: number) => {
  value = list[value];
  return mode == 0 ? list[value] : value;
};

const execute = (list: number[], input: number): number => {
  list = [...list];
  let pos = 0;

  for (; pos < list.length;) {
    const code = list[pos] % 100;
    const mode = Math.floor(list[pos] / 100);
    const first = get(list, mode % 10, pos + 1);
    const second = get(list, Math.floor(mode / 10), pos + 2);

    switch (code) {
      case OP.ADD:
        list[list[pos + 3]] = first + second;
        pos += 4;
        break;
      case OP.MULT:
        list[list[pos + 3]] = first * second;
        pos += 4;
        break;
      case OP.INPUT:
        list[list[pos + 1]] = input;
        pos += 2;
        break;
      case OP.OUTPUT:
        input = first;
        pos += 2;
        break;
      case OP.IF:
        pos = first ? second : pos + 3;
        break;
      case OP.UNLESS:
        pos = first ? pos + 3 : second;
        break;
      case OP.LESS_THAN:
        list[list[pos + 3]] = first < second ? 1 : 0;
        pos += 4;
        break;
      case OP.EQUAL:
        list[list[pos + 3]] = first == second ? 1 : 0;
        pos += 4;
        break;
      case OP.HALT:
        return input;
    }
  }

  throw "error";
};

const list = input.split(",").map((i) => ~~i);

const partOne = (): number => {
  return execute(list, 1);
};

const partTwo = (): number => {
  return execute(list, 5);
};

console.log(partOne());
console.log(partTwo());
