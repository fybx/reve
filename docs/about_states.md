# reve docs

"about states", revision 1
yigid balaban \<fyb@fybx.dev\>

## about states

different from configuration files, some information is temporary, and "local" to current runtime. some utilities, for example, may need a way to store and access variables. for that reason reve exposes 4 functions to work with states that can be temporary or permanent.

for this reason, states can be created/updated, deleted or read using reve.

### reve's API for states

Functions for working with states are defined in `_reve.sh`:

1. `util_create_state {type} {key} [value]`: Creates the state file. `{type}` can be `tmp` for temporary or `prs` for persistent.
1. `util_read_state {key}`: Returns the value read from file addressed by key. Will return `1` if an error occurs.
2. `util_write_state {key} {value}`: Writes the value to file addressed by key. Will **overwrite** without warning.
3. `util_delete_state {key}`: Deletes the file addressed by key. Will delete the containing folder, if the folder is empty.

### underlying implementation

- the `key`s are dot-delimited folders, subfolders and files. The last element of the key is assumed to be the file name.
- trying to read, write or delete a file that is not created will return an error.
- as a result of the rule above, writing a new state is not possible, you have to create it with an explicit type first.
- temporary states will be cleaned when the appropriate call is made (`reve state clean`)
