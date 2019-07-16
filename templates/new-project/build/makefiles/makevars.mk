# Gratis https://stackoverflow.com/questions/9551416/gnu-make-how-to-join-list-and-separate-it-with-separator
# A literal space.
space :=
space +=
comma := ,

# Joins elements of the list in arg 2 with the given separator.
#   1. Element separator.
#   2. The list.
join-with = $(subst $(space),$1,$(strip $2))
