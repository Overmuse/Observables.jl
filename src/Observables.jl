module Observables

using Dates

export
    # Observables
    Observable,
    StockObservable,
    FlowObservable,
    Close,
    Open,
    High,
    Low,
    Volume,

    # Operators
    Operator,
    BinaryOperator,
    GreaterThan,
    LessThan,
    EqualTo,
    SimpleMovingAverage,

    # Functions
    value

abstract type Observable end
abstract type StockObservable{T} <: Observable end
abstract type FlowObservable{T1, T2}  <: Observable end

value(x::StockObservable) = x.value

struct Close <: StockObservable{DateTime}
    timestamp::DateTime
    value::Float64
end

struct Open <: StockObservable{DateTime}
    timestamp::DateTime
    value::Float64
end

struct High <: FlowObservable{DateTime,DateTime}
    start_time::DateTime
    end_time::DateTime
    value::Float64
end

struct Low <: FlowObservable{DateTime,DateTime}
    start_time::DateTime
    end_time::DateTime
    value::Float64
end

struct Volume <: FlowObservable{DateTime,DateTime}
    start_time::DateTime
    end_time::DateTime
    value::Float64
end

abstract type Operator end
abstract type BinaryOperator{O1, O2} <: Operator end
struct GreaterThan{O1, O2} <: BinaryOperator{O1, O2}
    o1::O1
    o2::O2
end
value(x::GreaterThan) = value(x.o1) > value(x.o2)

struct LessThan{O1, O2} <: BinaryOperator{O1, O2}
    o1::O1
    o2::O2
end
value(x::LessThan) = value(x.o1) < value(x.o2)

struct EqualTo{O1, O2} <: BinaryOperator{O1, O2}
    o1::O1
    o2::O2
end
value(x::EqualTo) = value(x.o1) == value(x.o2)

abstract type NOperator{Int, O} end
struct SimpleMovingAverage{Int, O <: StockObservable}
    n::Int
    data::Vector{O}
end
function value(x::SimpleMovingAverage)
    if length(x.data) < x.n
        missing
    else
        sum(value, x.data) / x.n
    end
end

end # module
