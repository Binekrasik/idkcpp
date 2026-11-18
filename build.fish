#!/usr/bin/fish

# script that builds and runs the project.
# I should really use cmake though

argparse r/run h/help n/no-build -- $argv; or exit 3

# show the help menu if the help flag is set
if set -q _flag_h
    printf "Available arguments:\n"
    printf "-> $(set_color cyan)-h/--help$(set_color --reset)     - prints this message (optional)\n"
    printf "-> $(set_color cyan)-r/--run$(set_color --reset)      - runs the built binary (optional)\n"
    printf "-> $(set_color cyan)-n/--no-build$(set_color --reset) - skips the build (optional)\n"

    exit 0
end

function check_environment
    printf "-> Checking build environment\n"

    clang++ --version &> /dev/null; or {
        printf "-> $(set_color bryellow -r)clang++$(set_color normal) not found\n"
        exit 1
    }
end

function dc_build
    printf "-> Preparing build\n"

    rm -rf build/
    mkdir build; or return 1

    # a cache directory for the project to use as a temporary storage
    mkdir -p .cache/

    printf "-> Building project\n"

    set source_files ./**.cpp ./**.cc
    clang++ -std=c++20 $source_files -o build/bin; or return 1
end

function run_binary
    printf "-> Executing $(set_color blue)build/bin$(set_color --reset)\n"
    build/bin
    printf "--> Process exited with exit code $status\n"
end

# start build
if not set -q _flag_n
    # check the environment
    check_environment
    if test $status -ne 0
        printf "--> $(set_color red -r)Build failed\n"
        exit 1
    end

    dc_build
    if test $status -ne 0
        printf "--> $(set_color red -r)Build failed\n"
        exit 2
    end

    printf "\n--> $(set_color brgreen -r)Build complete$(set_color --reset)\n"
end

# run the binary if the run flag is set
if set -q _flag_r
    time run_binary
end

exit 0
