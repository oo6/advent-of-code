import readInputFile from "../read-input-file.ts";
import { init, execute, IContext } from "../intcode-computer.ts";

const executeOnce = (stack: IContext[]): IContext[] => {
  return stack.reduce((acc, c, i) => {
    acc.push(
      execute({
        ...c,
        inputs: [
          ...c.inputs,
          ...(i ? acc[i - 1] : stack[stack.length - 1]).outputs,
        ],
        outputs: [],
      }),
    );
    return acc;
  }, [] as IContext[]);
};

const executeLoop = (stack: IContext[]): IContext[] => {
  if (stack.every((c) => c.state == "halt")) {
    return stack;
  }

  return executeLoop(executeOnce(stack));
};

const initStack = (settings: number[]): IContext[] =>
  settings.map((s, i) => (init(readInputFile(), i ? [s] : [s, 0])));

const permutate = (list: number[]): number[][] => {
  if (list.length == 1) {
    return [list];
  }

  return list.reduce((acc, item, i) => {
    const rest = permutate([...list.slice(0, i), ...list.slice(i + 1)]);
    return acc.concat(rest.map((items) => [item, ...items]));
  }, [] as number[][]);
};

const partOne = (): number => {
  const signals = permutate([0, 1, 2, 3, 4]).map(
    (items) => executeOnce(initStack(items)).reverse()[0].outputs[0],
  );

  return Math.max(...signals);
};

const partTwo = (): number => {
  const signals = permutate([5, 6, 7, 8, 9]).map(
    (items) => executeLoop(initStack(items)).reverse()[0].outputs[0],
  );

  return Math.max(...signals);
};

console.log(partOne());
console.log(partTwo());
