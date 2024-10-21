<?php

namespace App\Security\WebserviceVus;

use Psr\Log\LoggerInterface;
use Symfony\Component\DependencyInjection\ParameterBag\ParameterBagInterface;
use Symfony\Component\HttpFoundation\RequestStack;
use Symfony\Component\Security\Http\Authenticator\AbstractAuthenticator;

abstract class VusAuthenticatorBase extends AbstractAuthenticator
{
    protected VusUserAuthenticationService $authenticationService;
    protected RequestStack $requestStack;
    protected ParameterBagInterface $params;
    protected LoggerInterface $logger;
    protected array $userInfo = [];

    public function __construct(
        VusUserAuthenticationService $authenticationService,
        ParameterBagInterface        $params,
        RequestStack                 $requestStack,
        LoggerInterface              $logger
    )
    {
        $vus = $params->get('vus');
        $authenticationService
            ->setWsUrl($vus['ws_url'])
            ->setWsUser($vus['ws_user'])
            ->setWsPass($vus['ws_pass']);

        if (!empty($vus['ws_app'])) {
            $authenticationService->setAplication($vus['ws_app']);
        }

        $this->authenticationService = $authenticationService;
        $this->params = $params;
        $this->requestStack = $requestStack;
        $this->logger = $logger;
    }
}
