namespace {{DomainName}}.Application.Commands;

public record AddEventCommand(string Name, DateTime StartDate, DateTime EndDate);
