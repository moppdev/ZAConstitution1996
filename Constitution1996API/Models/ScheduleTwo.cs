namespace Constitution1996API.Models
{
    // Models that return the results of .spGetScheduleTwo_OathsAffirmations, spGetScheduleTwo_Subsection
    // which returns the contents of Schedule 2
    public class ScheduleTwo_OathsAffirmation
    {
        public int SectionID {get; set;}
        public string SectionTitle {get; set;} = "N/A";
        public string? SectionText {get; set;} = null;
    }

    public class ScheduleTwo_Subsection
    {
        public int SectionID {get; set;}
        public string SubsectionID {get; set;} = "N/A";
        public string SubsectionText {get; set;} = "N/A";
    }

    // Model that combines the above two to return the entire Schedule's contents
    public class ScheduleTwo_Full
    {
        public IEnumerable<ScheduleTwo_OathsAffirmation> ScheduleTwo_Oaths {get; set;}
        public List<IEnumerable<ScheduleTwo_Subsection>>? Subsections {get; set;} = null;

        // constructor that sets the values
        public ScheduleTwo_Full(IEnumerable<ScheduleTwo_OathsAffirmation> scheduleTwo_Oaths, List<IEnumerable<ScheduleTwo_Subsection>>? subsections)
        {
            this.Subsections = subsections;
            this.ScheduleTwo_Oaths = scheduleTwo_Oaths;
        }
    }
}