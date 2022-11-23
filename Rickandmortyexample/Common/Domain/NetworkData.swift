enum NetworkData<Item> {
    case loading
    case data(Item)
    case error(String)
}
