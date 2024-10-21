<?php

namespace App\Security\WebserviceVus;

use InvalidArgumentException;
use Throwable;

class InvalidVusUserCredentialsException extends InvalidArgumentException
{
    public function __construct(Throwable $previous = null)
    {
        parent::__construct('Invalid VUS user credentials', 0, $previous);
    }
}
