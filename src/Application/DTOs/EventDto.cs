namespace {{DomainName}}.Application.DTOs;

public record EventDto(Guid Id, string Name, DateTime StartDate, DateTime EndDate, string Status);
