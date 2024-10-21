<?php

namespace App\Entity;

use Symfony\Component\Security\Core\User\UserInterface;

class User implements UserInterface
{
    protected string $username;
    protected array $roles;

    /**
     * A visual identifier that represents this user.
     *
     * @see UserInterface
     */
    public function getUsername(): string
    {
        return $this->username;
    }

    public function setUsername(string $username): self
    {
        $this->username = $username;

        return $this;
    }

    public function getUserIdentifier(): string
    {
        return $this->getUsername();
    }

    public function getRoles(): array
    {
        return $this->roles ?? ['ROLE_USER'];
    }

    public function setRoles(array $roles): self
    {
        // Ensures always exists user role.
        $this->roles = array_unique(array_merge($roles, ['ROLE_USER']));
        return $this;
    }

    /**
     * @see UserInterface
     */
    public function getPassword(): ?string
    {
        // not needed for apps that do not check user passwords.
        return null;
    }

    /**
     * @see UserInterface
     */
    public function getSalt(): ?string
    {
        // not needed for apps that do not check user passwords.
        return null;
    }

    /**
     * @see UserInterface
     */
    public function eraseCredentials()
    {
        // If you store any temporary, sensitive data on the user, clear it here
        // $this->plainPassword = null;
    }
}
