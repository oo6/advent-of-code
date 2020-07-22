export interface IContext {
  program: Map<number, number>;
  inputs: number[];
  outputs: number[];
  pos: number;
  state: "cont" | "wait" | "halt";
  base: number;
}

enum MODE {
  position,
  immediate,
  relative,
}

type Value = [MODE, number];

const get = ({ program, base }: IContext, [mode, value]: Value): number => {
  if (mode == MODE.relative) {
    if (base == undefined) throw "error";
    return program.get(base + value) || 0;
  }

  return mode == MODE.position ? (program.get(value) || 0) : value;
};

const set = (
  context: IContext,
  [mode, index]: Value,
  value: number,
): Map<number, number> =>
  context.program.set(
    mode == MODE.relative ? context.base + index : index,
    value,
  );

const add = (
  context: IContext,
  left: Value,
  right: Value,
  store: Value,
): IContext => ({
  ...context,
  program: set(context, store, get(context, left) + get(context, right)),
  state: "cont",
});

const mult = (
  context: IContext,
  left: Value,
  right: Value,
  store: Value,
): IContext => ({
  ...context,
  program: set(context, store, get(context, left) * get(context, right)),
  state: "cont",
});

const input = (context: IContext, store: Value): IContext => {
  if (context.inputs.length) {
    return {
      ...context,
      inputs: context.inputs.slice(1),
      program: set(context, store, context.inputs[0]),
      state: "cont",
    };
  }

  return { ...context, state: "wait" };
};

const output = (context: IContext, value: Value): IContext => ({
  ...context,
  outputs: [...context.outputs, get(context, value)],
  state: "cont",
});

const jumpIf = (
  context: IContext,
  condition: Value,
  where: Value,
): IContext => {
  if (get(context, condition)) {
    return { ...context, pos: get(context, where), state: "cont" };
  }

  return { ...context, state: "cont" };
};

const jumpUnless = (
  context: IContext,
  condition: Value,
  where: Value,
): IContext => {
  if (get(context, condition)) {
    return { ...context, state: "cont" };
  }

  return { ...context, pos: get(context, where), state: "cont" };
};

const lessThan = (
  context: IContext,
  left: Value,
  right: Value,
  store: Value,
): IContext => ({
  ...context,
  program: set(
    context,
    store,
    get(context, left) < get(context, right) ? 1 : 0,
  ),
  state: "cont",
});

const equal = (
  context: IContext,
  left: Value,
  right: Value,
  store: Value,
): IContext => ({
  ...context,
  program: set(
    context,
    store,
    get(context, left) == get(context, right) ? 1 : 0,
  ),
  state: "cont",
});

const adjustbase = (
  context: IContext,
  offset: Value,
): IContext => ({
  ...context,
  base: context.base
    ? context.base + get(context, offset)
    : get(context, offset),
});

const halt = (context: IContext): IContext => ({ ...context, state: "halt" });

const Functions = {
  1: add,
  2: mult,
  3: input,
  4: output,
  5: jumpIf,
  6: jumpUnless,
  7: lessThan,
  8: equal,
  9: adjustbase,
  99: halt,
};

const parameters = (
  { program, pos }: IContext,
  code: number,
  length: number,
): Value[] => {
  let mode = Math.floor(code / 100);

  return Array.from(Array(length), (_, i) => {
    const value: Value = [mode % 10, program.get(pos + i + 1) as number];
    mode = Math.floor(mode / 10);

    return value;
  });
};

export const execute = (context: IContext): IContext => {
  while (true) {
    const code = context.program.get(context.pos) as number;
    const func = Functions[(code % 100) as 99] as (...args: any[]) => IContext;
    const newContext = func(
      context,
      ...parameters(context, code, func.length - 1),
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

export const init = (content: string, inputs: number[] = []): IContext => {
  const program = content.split(",")
    .reduce((acc, v, k) => acc.set(k, +v), new Map() as Map<number, number>);

  return {
    program,
    inputs,
    outputs: [],
    pos: 0,
    state: "cont",
    base: 0,
  };
};
