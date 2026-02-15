import logging
from typing import Optional

logger = logging.getLogger(__name__)

def process_payment(amount: float, user_id: str) -> Optional[dict]:
    """
    Process payment with proper error handling.
    
    Args:
        amount: Payment amount in USD
        user_id: Unique user identifier
        
    Returns:
        Payment receipt dict or None if failed
        
    Raises:
        ValueError: If amount is negative
    """
    try:
        if amount < 0:
            raise ValueError(f"Amount cannot be negative: {amount}")
            
        # Process payment logic here
        receipt = {"user": user_id, "amount": amount, "status": "success"}
        logger.info(f"Payment processed for user {user_id}")
        return receipt
        
    except ValueError as e:
        logger.error(f"Validation error: {e}")
        raise
    except Exception as e:
        logger.exception(f"Payment failed for user {user_id}: {e}")
        return None
