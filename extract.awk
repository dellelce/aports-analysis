
BEGIN { state = 0; }

# variables to ignore, for now
/builddir/ { next }
/_buildtags/ { next }

{
  # add some spaces as appropriate
  gsub(/\(\)/, " ()");
  # cleanup
  gsub(/ $/, "");
}

$1 ~ /^pkgname/ \
{
  gsub(/=/, " ")
  print name " " $0

  if ($2 !~ /\$/)
  {
    name = $2
  }
  next
}

$1 ~ /^pkgver/ \
{
  gsub(/=/, " ")
  print name " " $0
  next
}

state == 0 && $1 ~ /^source/ \
{
  print name " " $0

  cnt = split($0, url_a, "\"");
  if (cnt == 2) # cnt = 2: single double-quote in the line!
  {
    state = 2
  }
  next
}

# reading list of "sources" over multiple lines
# 1. line has no termination
state == 2 && !/\"/ \
{ print name " " $0; next; }
# 2. line has termination!
state == 2 && /\"/ \
{ print name " " $0; state = 0; next; }

state == 0 && ($1 ~ /^build/ || $1 ~ /^_build/) \
{
  state = 1
  pos = 0
  print name " " pos " " $0
  pos = pos + 1
  next
}

state == 1 && /}/ \
{
  print name " " pos " " $0
  pos = pos + 1
  state = 0
  next
}

state == 1 \
{
  print name " " pos " " $0
  pos = pos + 1
  next
}

