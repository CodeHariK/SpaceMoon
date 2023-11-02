import { Const } from "../Gen/data";
import { toMap } from "./map";

export function constName(name: number) {
    return toMap(Const).get(name.toString()) as string;
}

