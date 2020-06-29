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

export const execute = (list: number[], inputs: number[]): number[] => {
  list = [...list];
  inputs = [...inputs];
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
        if (inputs.length) {
          list[list[pos + 1]] = inputs.shift() as number;
          pos += 2;
        }
        break;
      case OP.OUTPUT:
        inputs.push(first);
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
        return inputs;
    }
  }

  throw "error";
};

const permutate = (list: number[]): number[][] => {
  if (list.length == 1) {
    return [list];
  }

  return list.reduce(
    (acc, item, i) => {
      const rest = permutate([...list.slice(0, i), ...list.slice(i + 1)]);
      return acc.concat(rest.map((items) => [item, ...items]));
    },
    [] as number[][],
  );
};

const program = input.split(",").map((i) => ~~i);

const partOne = (): number => {
  const signals = permutate([0, 1, 2, 3, 4]).map((items) =>
    items.reduce((acc, num) => {
      return execute(program, [num, acc])[0];
    }, 0)
  );
  return Math.max(...signals);
};

console.log(partOne());
