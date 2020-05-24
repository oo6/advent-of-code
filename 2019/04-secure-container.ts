const input = "356261-846303";
const [min, max] = input.split("-").map((i) => ~~i);

const testDecrease = (str: string): boolean => {
  return str == str.split("").sort().join("");
};

const testSame = (str: string): boolean => {
  return str != [...new Set(str.split(""))].join("");
};

const testSameNotLarger = (str: string): boolean => {
  const same = str.split("").reduce(
    (acc: { [propName: string]: number }, c, i) => {
      if (acc[c]) {
        acc[c]++;
      } else if (c == str[i + 1]) {
        acc[c] = 1;
      }

      return acc;
    },
    {},
  );

  return Object.values(same).sort()[0] == 2;
};

const count = (tests: Function[]): number => {
  let count = 0;

  for (let i = min; i <= max; i++) {
    const str = String(i);

    if (tests.every((t) => t(str))) {
      count++;
    }
  }

  return count;
};

const partOne = (): number => {
  return count([testSame, testDecrease]);
};

const partTwo = (): number => {
  return count([testSameNotLarger, testDecrease]);
};

console.log(partOne());
console.log(partTwo());

export {};
