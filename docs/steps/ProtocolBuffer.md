# [Protocol Buffers](https://protobuf.dev/)

Protocol Buffers are language-neutral, platform-neutral extensible mechanisms for serializing structured data.

```code
> Install protoc compiler : https://github.com/protocolbuffers/protobuf/releases/

> Flutter : flutter pub add protobuf

> Install Buf.build : https://buf.build/docs/installation#npm

mkdir proto
cd proto
npm install @bufbuild/buf
npx buf mod init

Add Plugins in buf.gen.yaml

### To generate files
npx buf generate lib
```
