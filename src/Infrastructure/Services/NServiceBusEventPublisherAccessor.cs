    using {{DomainName}}.Application.Services;

namespace {{DomainName}}.Infrastructure.Services
{
    public static class NServiceBusEventPublisherAccessor
    {
        public static ISenderService? Instance { get; set; }
    }
}
