import readInputFile from "../read-input-file.ts";

const input = readInputFile();

interface Material {
  name: string;
  required: number;
}

interface Formula {
  produced: number;
  inputs: Material[];
}

const reactions = input.split("\n").reduce((acc, l) => {
  const [inputs, output] = l.split(" => ");
  const [produced, name] = output.split(" ");

  acc[name] = {
    produced: ~~produced,
    inputs: inputs.split(", ").map((i) => {
      const [required, name] = i.split(" ");

      return { name, required: ~~required };
    }),
  };

  return acc;
}, {} as Record<string, Formula>);

const produce = (
  name: string,
  count = 1,
  stock: Record<string, number> = {},
): number => {
  if (name == "ORE") {
    return count;
  }

  const formula = reactions[name];

  count -= stock[name] ?? 0;
  stock[name] = Math.ceil(count / formula.produced) * formula.produced - count;
  if (stock[name] == 0) {
    delete stock[name];
  }

  return formula.inputs.reduce(
    (acc, i) =>
      acc +
      produce(i.name, Math.ceil(count / formula.produced) * i.required, stock),
    0,
  );
};

const partOne = (): number => {
  return produce("FUEL");
};

const partTwo = (): number => {
  const units = 1000000000000;
  let max = 1;

  while (true) {
    max *= 2;

    if (produce("FUEL", max) >= units) {
      break;
    }
  }

  // https://en.wikipedia.org/wiki/Binary_search_algorithm
  let min = max / 2;
  while (min <= max) {
    const mid = Math.floor((min + max) / 2);
    if (min == mid) {
      return mid;
    }

    const amount = produce("FUEL", mid);
    if (amount < units) {
      min = mid;
    } else if (amount > units) {
      max = mid;
    } else {
      return mid;
    }
  }

  throw "error";
};

console.log(partOne());
console.log(partTwo());
