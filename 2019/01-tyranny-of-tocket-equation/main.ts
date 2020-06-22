import readInputFile from "../read-input-file.ts";

const input = readInputFile();

const calculateFuel = (mass: number, repeat = true, sum = 0): number => {
  const fuel = Math.floor(mass / 3 - 2);

  if (!repeat) {
    return fuel;
  }

  if (fuel < 0) {
    return sum;
  }

  return calculateFuel(fuel, true, sum + fuel);
};

const partOne = (): number => {
  return input.split("\n").reduce(
    (acc, item) => acc + calculateFuel(~~item, false),
    0,
  );
};

const partTwo = (): number => {
  return input.split("\n").reduce(
    (acc, item) => acc + calculateFuel(~~item),
    0,
  );
};

console.log(partOne());
console.log(partTwo());
