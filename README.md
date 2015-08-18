* Working Features:

(1) All Builtin Functions (2)Aliases/Alias Processing (3) Environmental Variable Expansion

* Features that require further testing:

(1) Alias processing (2) Environmental Variable Expansion

*	Current Bugs:

Alias commands apparently cannot have spaces or consist of a single character.

Unalias will execute the alias it is unaliasing, but will successfully unalias.

Printenv command before setenv causes segmentation fault. (Alex : I do not encounter this bug.)

