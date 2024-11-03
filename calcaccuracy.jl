using ArgParse
using Printf
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
    number_of_trials = 10000

    raw_numbers = rand(-1.0:0.000001:1.0, sample_size, number_of_inputs)
    operation_tree = generate_random_calculation_tree(number_of_inputs, number_of_operations)

    exact_answer = vec(operation_tree(raw_numbers))
    if any(isnan, exact_answer) || any(isinf, exact_answer)
        nan_count = count(isnan, exact_answer)
        inf_count = count(isinf, exact_answer)
        total_bad = nan_count + inf_count
        if total_bad / length(exact_answer) < 0.01
            good_indices = .!isnan.(exact_answer) .& .!isinf.(exact_answer)
            exact_answer = exact_answer[good_indices]
            raw_numbers = raw_numbers[good_indices, :]
            println("Removed bad initial value sets: NaN: $nan_count, Inf: $inf_count")
        else
            println("bad function: NaN: $nan_count, Inf: $inf_count")
            return
        end
    end
    sample_size = length(exact_answer)

    trial_means = Vector{Float64}(undef, number_of_trials)
    trial_std = Vector{Float64}(undef, number_of_trials)
    for trial in 1:number_of_trials
        wiggle = randn(sample_size, number_of_inputs) .* 10.0^(-precision)
        wiggled_numbers = raw_numbers .+ wiggle
        deltas = vec(operation_tree(wiggled_numbers)) .- exact_answer
        trial_means[trial] = mean(deltas)
        trial_std[trial] = std(deltas)
    end

    if all(isnan, trial_means) || all(isnan, trial_std)
        println("Everything is NaN - something went wrong")
        return
    end

    mean_result = mean(trial_means)
    std_result = mean(trial_std)

    @printf("Mean: %.3e, stddev: %.3e, n_trials: %d\n", mean_result, std_result, sample_size)
end

main()