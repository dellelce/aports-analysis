
BEGIN { state = 0; }

/builddir/ { next }

# add some spaces as appropriate
{ gsub(/\(\)/, " ()"); }

state == 0 && ($1 ~ /^build/ || $1 ~ /^_build/) && ($1 ~ /()/ || $1 ~ /()/) \
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

