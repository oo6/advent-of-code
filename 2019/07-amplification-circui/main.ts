import readInputFile from "../read-input-file.ts";

interface Context {
  program: number[];
  inputs: number[];
  outputs: number[];
  pos: number;
  state: "cont" | "wait" | "halt";
}

type Value = ["position" | "immediate", number];

const get = (
  list: number[],
  mode: "position" | "immediate",
  value: number,
): number => (mode == "position" ? list[value] : value);

const set = (list: number[], store: number, value: number): number[] => [
  ...list.slice(0, store),
  value,
  ...list.slice(store + 1),
];

const add = (
  { program, ...context }: Context,
  left: Value,
  right: Value,
  [, store]: Value,
): Context => ({
  ...context,
  program: set(
    program,
    store,
    get(program, ...left) + get(program, ...right),
  ),
  state: "cont",
});

const mult = (
  { program, ...context }: Context,
  left: Value,
  right: Value,
  [, store]: Value,
): Context => ({
  ...context,
  program: set(
    program,
    store,
    get(program, ...left) * get(program, ...right),
  ),
  state: "cont",
});

const input = (context: Context, [, store]: Value): Context => {
  if (context.inputs.length) {
    return {
      ...context,
      inputs: context.inputs.slice(1),
      program: set(context.program, store, context.inputs[0]),
      state: "cont",
    };
  }

  return { ...context, state: "wait" };
};

const output = ({ outputs, ...context }: Context, value: Value): Context => ({
  ...context,
  outputs: [...outputs, get(context.program, ...value)],
  state: "cont",
});

const jumpIf = (context: Context, condition: Value, where: Value): Context => {
  if (get(context.program, ...condition)) {
    return { ...context, pos: get(context.program, ...where), state: "cont" };
  }

  return { ...context, state: "cont" };
};

const jumpUnless = (
  context: Context,
  condition: Value,
  where: Value,
): Context => {
  if (get(context.program, ...condition)) {
    return { ...context, state: "cont" };
  }

  return { ...context, pos: get(context.program, ...where), state: "cont" };
};

const lessThan = (
  { program, ...context }: Context,
  left: Value,
  right: Value,
  [, store]: Value,
): Context => ({
  ...context,
  program: set(
    program,
    store,
    get(program, ...left) < get(program, ...right) ? 1 : 0,
  ),
  state: "cont",
});

const equal = (
  { program, ...context }: Context,
  left: Value,
  right: Value,
  [, store]: Value,
): Context => ({
  ...context,
  program: set(
    program,
    store,
    get(program, ...left) == get(program, ...right) ? 1 : 0,
  ),
  state: "cont",
});

const halt = (context: Context): Context => ({ ...context, state: "halt" });

const Functions = {
  1: add,
  2: mult,
  3: input,
  4: output,
  5: jumpIf,
  6: jumpUnless,
  7: lessThan,
  8: equal,
  99: halt,
};

const parameters = (
  list: number[],
  pos: number,
  code: number,
  length: number,
): Value[] => {
  let mode = Math.floor(code / 100);

  return Array.from(Array(length), (_, i) => {
    const value: Value = [mode % 10 ? "immediate" : "position", list[pos + i]];
    mode = Math.floor(mode / 10);

    return value;
  });
};

const execute = (context: Context): Context => {
  while (true) {
    const code = context.program[context.pos];
    const func = Functions[(code % 100) as 99] as (...args: any[]) => Context;
    const newContext = func(
      context,
      ...parameters(context.program, context.pos + 1, code, func.length - 1),
    );

    if (newContext.state != "cont") {
      return newContext;
    }

    const pos = context.pos == newContext.pos
      ? context.pos + func.length
      : newContext.pos;
    context = { ...newContext, pos };
  }
};

const executeOnce = (stack: Context[]): Context[] => {
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
  }, [] as Context[]);
};

const executeLoop = (stack: Context[]): Context[] => {
  if (stack.every((c) => c.state == "halt")) {
    return stack;
  }

  return executeLoop(executeOnce(stack));
};

const initStack = (settings: number[]): Context[] => {
  return settings.map((s, i) => ({
    program: readInputFile().split(",").map((i) => ~~i),
    inputs: i ? [s] : [s, 0],
    outputs: [],
    pos: 0,
    state: "cont",
  }));
};

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
