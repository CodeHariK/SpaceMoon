import { Const, Role, Visible } from "../Gen/data";
import { toMap } from "./map";

export function constName(name: Const) {
    return toMap(Const).get(name.toString()) as string;
}

export function visibleName(name: Visible) {
    return toMap(Visible).get(name.toString()) as string;
}


export function roleName(name: Role) {
    return toMap(Role).get(name.toString()) as string;
}

