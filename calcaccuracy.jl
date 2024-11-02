# What am I doing wrong with environments that I needed these two lines?
# import Pkg
# Pkg.add("ArgParse")
using ArgParse

using Random
using Statistics

# Define possible operations
const OPERATIONS = [
    (.+), (.-), (.*), (./), x -> sqrt.(abs.(x)), x -> x .^ 2
]

"""
    generate_random_calculation_tree(num_inputs::Int, num_operations::Int) -> Function

Generate a random calculation tree with the specified number of inputs and operations.

# Arguments
- `num_inputs::Int`: Number of inputs to choose from.
- `num_operations::Int`: Number of operations to include in the tree.

# Returns
- `Function`: A function representing the calculation tree.
"""
function generate_random_calculation_tree(num_inputs::Int, num_operations::Int)::Function
    if num_operations == 0
        col = rand(1:num_inputs)  # Randomly select a column
        return x -> x[:, col]  # Return the selected column
    end

    # Randomly select an operation
    operation = rand(OPERATIONS)

    if operation in [(.+), (.-), (.*), (./)]
        left_tree = generate_random_calculation_tree(num_inputs, num_operations - 1)
        right_tree = generate_random_calculation_tree(num_inputs, num_operations - 1)
        return x -> operation(left_tree(x), right_tree(x))
    else
        sub_tree = generate_random_calculation_tree(num_inputs, num_operations - 1)
        return x -> operation(sub_tree(x))
    end
end

"""
    execute_calculation_tree(tree::Function, matrix::Matrix{Float64}) -> Matrix{Float64}

Execute the calculation tree on the given matrix.

# Arguments
- `tree::Function`: The calculation tree function.
- `matrix::Matrix{Float64}`: The matrix to apply the calculation tree on.

# Returns
- `Matrix{Float64}`: The resulting matrix after applying the calculation tree.
"""
function execute_calculation_tree(tree::Function, matrix::Matrix{Float64})::Vector{Float64}
    r = tree(matrix)
    # Why do I need to do this? I mean, I get it, but...
    r = vec(r)
    return r
end

function main()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--precision"
        help = "Order of magnitude of the precision (e.g. 5, means 1e-5)"
        arg_type = Int
        default = 5
    end
    @add_arg_table s begin
        "--depth"
        help = "Depth of the calculation tree"
        arg_type = Int
        default = 1
    end

    parsed_args = parse_args(s)
    precision = parsed_args["precision"]
    number_of_operations = parsed_args["depth"]

    number_of_inputs = 10
    sample_size = 10000
    number_of_trials = 1000

    # Next, lets generate the base numbers, and run the calculation according to
    # that.
    raw_numbers = rand(-1.0:1.0, sample_size, number_of_inputs)
    operation_tree = generate_random_calculation_tree(number_of_inputs, number_of_operations)

    # for each trial, calculate a new wiggle, apply the tree, and save the result.
    results = Matrix{Float64}(undef, sample_size, number_of_trials)
    for trial in 1:number_of_trials
        wiggle = rand(-1.0:1.0, sample_size, number_of_inputs) .* 10.0^(-precision)
        wiggled_numbers = raw_numbers .+ wiggle
        results[:, trial] = execute_calculation_tree(operation_tree, wiggled_numbers)
    end

    # Calculate the mean and standard deviation of the results, after subtracting
    # off the exact anwer for all the trials.
    exact_answer = execute_calculation_tree(operation_tree, raw_numbers)
    delta_results = results .- exact_answer
    mean = Statistics.mean(delta_results)
    std = Statistics.std(delta_results)

    # And print out the results with basic info.
    println("Mean: $mean, stddev: $std")
end

main()