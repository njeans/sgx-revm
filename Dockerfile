FROM ubuntu:22.04

RUN apt-get update && \
 apt-get install -y pkg-config libssl-dev protobuf-compiler cmake clang curl gcc-multilib netcat 

#Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly
RUN rustup default nightly

#Fortanix
RUN rustup target add x86_64-fortanix-unknown-sgx --toolchain nightly
RUN cargo install fortanix-sgx-tools sgxs-tools
RUN echo '[target.x86_64-fortanix-unknown-sgx]\nrunner = "ftxsgx-runner-cargo"' >> ~/.cargo/config 

COPY . /sgx-revm
WORKDIR /sgx-revm
# RUN cargo build --release --target x86_64-fortanix-unknown-sgx
CMD cargo run --release --target x86_64-fortanix-unknown-sgx
