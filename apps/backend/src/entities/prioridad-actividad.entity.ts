import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Actividad } from './actividad.entity';

@Entity('prioridad_actividad')
export class PrioridadActividad {
  @PrimaryGeneratedColumn()
  id_prioridad_actividad: number;

  @Column({ length: 50 })
  nombre_prioridad: string;

  @Column({ length: 255, nullable: true })
  descripcion: string;

  @Column({ default: true })
  estado: boolean;

  @OneToMany(() => Actividad, (actividad) => actividad.prioridad)
  actividades: Actividad[];
}
