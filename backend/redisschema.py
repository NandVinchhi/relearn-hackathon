import redis
from credentials import REDIS_URL, REDIS_PASSWORD
import redis
import redis.commands.search.aggregation as aggregations
import redis.commands.search.reducers as reducers
from redis.commands.search.field import TextField, NumericField, TagField
from redis.commands.search.indexDefinition import IndexDefinition, IndexType

r = redis.Redis(
  host=REDIS_URL,
  port=17728,
  password=REDIS_PASSWORD
)

# schema = (
#     TextField("$.email", as_name="email"),
#     TextField("$.reel_id", as_name="reel_id")
# )

# index = r.ft("idx:likes")
# index.create_index(
#     schema,
#     definition=IndexDefinition(prefix=["likes:"], index_type=IndexType.JSON),
# )

# schema1 = (
#     TextField("$.email", as_name="email"),
#     TextField("$.name", as_name="name"),
#     TextField("$.profile_url", as_name="profile_url"),
#     TextField("$.reel_id", as_name="reel_id"),
#     TextField("$.content", as_name="content"),
#     TextField("$.created_at", as_name="created_at"),
#     TextField("$.edison_reply", as_name="edison_reply")
# )

# index1 = r.ft("idx:comments")
# index1.create_index(
#     schema1,
#     definition=IndexDefinition(prefix=["comments:"], index_type=IndexType.JSON),
# )

schema2 = (
    NumericField("$.unit", as_name="unit"),
    NumericField("$.reel", as_name="reel")
)

index2 = r.ft("idx:current")
index2.create_index(
    schema2,
    definition=IndexDefinition(prefix=["current:"], index_type=IndexType.JSON),
)