function toMap(obj: Object) {
    // Array.from(new Map(Object.entries(m)), ([key, value]) => ({ key, value })).forEach((e) => { console.log(e) })
    return new Map(Object.entries(obj));
}

function toArray(map: Map<any, any>) {
    let arr = Array.from(toMap(map).entries());
    return arr.map((o, i) => ({ 'key': o[0], 'value': o[1] }));
}