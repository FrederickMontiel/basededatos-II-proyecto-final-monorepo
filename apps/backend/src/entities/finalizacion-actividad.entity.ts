import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Actividad } from './actividad.entity';

@Entity('finalizacion_actividad')
export class FinalizacionActividad {
  @PrimaryGeneratedColumn()
  id_finalizacion_actividad: number;

  @Column({ length: 50 })
  nombre_finalizacion: string;

  @Column({ length: 255, nullable: true })
  descripcion: string;

  @Column({ default: true })
  estado: boolean;

  @OneToMany(() => Actividad, (actividad) => actividad.finalizacion)
  actividades: Actividad[];
}
