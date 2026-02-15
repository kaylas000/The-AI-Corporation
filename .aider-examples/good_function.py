def calculate_total(items: list[dict]) -> float:
    """
    Calculate total price from list of items.
    
    Args:
        items: List of dicts with 'price' key
        
    Returns:
        Total sum of all prices
    """
    return sum(item['price'] for item in items)
