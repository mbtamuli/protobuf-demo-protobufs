regenerate-protobuf-classes: output-dir
	protoc \
		--proto_path=proto \
		--go_out=pb \
		--go_opt=paths=source_relative \
		person.proto

output-dir:
	mkdir -p pb

clean:
	rm -rf pb