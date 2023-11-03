import { Const, Role } from "../Gen/data";
import { toMap } from "./map";

export function constName(name: Const) {
    return toMap(Const).get(name.toString()) as string;
}

export function roleName(name: Role) {
    return toMap(Role).get(name.toString()) as string;
}

