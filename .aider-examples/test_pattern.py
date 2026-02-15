import pytest
from unittest.mock import Mock, patch

class TestPaymentProcessor:
    """Test suite for payment processing."""
    
    def test_valid_payment(self):
        """Should process valid payment successfully."""
        result = process_payment(100.0, "user123")
        
        assert result is not None
        assert result["status"] == "success"
        assert result["amount"] == 100.0
    
    def test_negative_amount_raises_error(self):
        """Should reject negative amounts."""
        with pytest.raises(ValueError, match="cannot be negative"):
            process_payment(-50.0, "user123")
    
    @patch('logging.Logger.error')
    def test_logs_error_on_failure(self, mock_logger):
        """Should log errors properly."""
        with pytest.raises(ValueError):
            process_payment(-10, "user123")
        
        mock_logger.assert_called_once()
