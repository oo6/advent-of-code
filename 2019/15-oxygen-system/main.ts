import readInputFile from "../read-input-file.ts";
import { execute, IContext, init } from "../intcode-computer.ts";

const input = readInputFile();

type Position = [number, number];

enum Command {
  north = 1,
  south,
  west,
  east,
}

enum Status {
  wall = 0,
  blank,
  oxygen,
}

const nextPosition = ([x, y]: Position, command: Command): Position => {
  switch (command) {
    case Command.north:
      return [x, y + 1];
    case Command.south:
      return [x, y - 1];
    case Command.west:
      return [x - 1, y];
    case Command.east:
      return [x + 1, y];
    default:
      throw "error";
  }
};

const nextCommand = (command: Command): Command => {
  const next = command + 1;
  return next > 4 ? next - 4 : next;
};

const partOne = (): number => {
  let context = init(input), command = Command.north;
  const route = [[0, 0]] as Position[];
  const map = { "0,0": context } as Record<string, IContext>;

  while (true) {
    const back = [Command.north, Command.south, Command.west, Command.east]
      .every((c) => map[nextPosition(route[0], c).join(",")]);

    if (back) {
      route.shift();
      const [x, y] = route[0];
      context = map[`${x},${y}`];

      continue;
    }

    const nextPos = nextPosition(route[0], command);
    if (map[nextPos.join(",")]) {
      command = nextCommand(command);

      continue;
    }

    context = execute(
      { ...context, program: new Map(context.program), inputs: [command] },
    );
    map[nextPos.join(",")] = context;
    const status = context.outputs.reverse()[0];

    if (status == Status.wall) {
      command = nextCommand(command);
      continue;
    }

    if (status == Status.oxygen) {
      return route.length;
    }

    route.unshift(nextPos);
  }
};

const partTwo = (): number => {
  const map = { "0,0": [init(input), 1] } as Record<string, [IContext, Status]>;
  let spiders = [[0, 0]] as Position[];

  while (spiders.length) {
    spiders = [Command.north, Command.south, Command.west, Command.east].map((
      c,
    ) =>
      spiders.reduce((acc, p) => {
        const nextPos = nextPosition(p, c);

        if (map[nextPos.join(",")]) {
          return acc;
        }

        let context = map[p.join(",")][0];
        context = execute(
          { ...context, program: new Map(context.program), inputs: [c] },
        );
        const status = context.outputs.reverse()[0];
        map[nextPos.join(",")] = [context, status];

        if (status != Status.wall) {
          acc.push(nextPos);
        }

        return acc;
      }, [] as Position[])
    ).flat();
  }

  let i = 0;
  while (true) {
    i += 1;

    Object.keys(map).reduce((acc, k) => {
      map[k][1] == Status.oxygen && acc.push(k);
      return acc;
    }, [] as string[]).forEach((k) => {
      [Command.north, Command.south, Command.west, Command.east].forEach(
        (c) => {
          const nextPos = nextPosition(
            k.split(",").map((i) => ~~i) as Position,
            c,
          ).join(",");
          if (map[nextPos][1] == Status.blank) {
            map[nextPos][1] = Status.oxygen;
          }
        },
      );
    }, map);

    if (Object.keys(map).every((k) => map[k][1] != Status.blank)) {
      return i;
    }
  }
};

console.log(partOne());
console.log(partTwo());
