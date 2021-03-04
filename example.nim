import termy
type Custom = ref object of Item
    id: int
method command(c: Custom, k: Key) =
    var newPage: seq[Item]
    for i in 1..10:
        newPage.add(Item(text: $(i * c.id), status: "nothing"))
    newPage.show()
var Items: seq[Item]
for i in 0..10:
    Items.add(Custom(text: $i, status: "Status: " & $i, id: i))
Items.show()


termy.start()
