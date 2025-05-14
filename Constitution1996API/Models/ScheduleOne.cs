namespace Constitution1996API.Models
{
    // These models contain each information found in Schedule 1 and 1A, as the result of
    // spGetScheduleOne_NationalFlag and spGetScheduleOneA_GeoAreasProvinces
    public class ScheduleOne_NationalFlag
    {
        public int SectionID {get; set;}
        public string SectionText {get; set;} = "";
    }

    public class ScheduleOneA_GeoAreasProvince
    {
        public string Province {get; set;} = "";
        public string MapCSV {get; set;} = "";
    }
}