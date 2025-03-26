:- initialization(main).
:- dynamic(var_value/2).

main :-
    write('*** PROLOG CALCULATOR***'), nl,
    calculator_loop.

calculator_loop :-
    write('> '),
    read(Input),
    (   Input == exit
    ->  write('Goodbye!'), nl
    ;   process_input(Input),
        calculator_loop
    ).

process_input(Input) :-
    catch(
        (   Input = (Var = Expr), atom(Var)
        ->  evaluate(Expr, Result),
            retractall(var_value(Var, _)),
            assertz(var_value(Var, Result)),
            write(Var), write(' = '), write(Result), nl
        ;   evaluate(Input, Result),
            write('= '), write(Result), nl
        ),
        Error,
        handle_error(Error)
    ).

evaluate(X, X) :- number(X).
evaluate(Var, Value) :- atom(Var), var_value(Var, Value).
evaluate(A+B, R) :- evaluate(A, A1), evaluate(B, B1), R is A1 + B1.
evaluate(A-B, R) :- evaluate(A, A1), evaluate(B, B1), R is A1 - B1.
evaluate(A*B, R) :- evaluate(A, A1), evaluate(B, B1), R is A1 * B1.
evaluate(A/B, R) :- evaluate(A, A1), evaluate(B, B1), B1 =\= 0, R is A1 / B1.

handle_error(error(existence_error(variable, Var), _)) :-
    write('ERROR: Undefined variable '), write(Var), nl.
handle_error(error(evaluation_error(zero_divisor), _)) :-
    write('ERROR: Division by zero'), nl.
handle_error(_) :-
    write('ERROR: Invalid input'), nl.
